import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';
import Parse from 'parse/node';
import { PDFDocument, StandardFonts, rgb } from 'pdf-lib';

const require = createRequire(import.meta.url);
const forge = require('node-forge');

const smokePassword = 'sealhouse-smoke-password';
const pfxPassphrase = 'sealhouse-smoke-passphrase';
const smokeSignaturePng =
  'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/p9sAAAAASUVORK5CYII=';

function configureParseClient() {
  Parse.User.enableUnsafeCurrentUser();
  Parse.initialize('test', 'test');
  Parse.masterKey = 'test';
  Parse.serverURL = 'http://localhost:30001/test';
}

function createSmokePfxBase64() {
  const keys = forge.pki.rsa.generateKeyPair(1024);
  const cert = forge.pki.createCertificate();
  cert.publicKey = keys.publicKey;
  cert.serialNumber = String(Date.now());
  cert.validity.notBefore = new Date();
  cert.validity.notAfter = new Date();
  cert.validity.notAfter.setFullYear(cert.validity.notBefore.getFullYear() + 1);

  const attrs = [
    { name: 'commonName', value: 'Sealhouse Smoke Test' },
    { name: 'organizationName', value: 'Sealhouse Test Fixtures' },
    { shortName: 'OU', value: 'Generated Test Data' },
  ];
  cert.setSubject(attrs);
  cert.setIssuer(attrs);
  cert.setExtensions([
    { name: 'basicConstraints', cA: false },
    { name: 'keyUsage', digitalSignature: true, nonRepudiation: true },
    { name: 'extKeyUsage', emailProtection: true },
    { name: 'subjectKeyIdentifier' },
  ]);
  cert.sign(keys.privateKey, forge.md.sha256.create());

  const p12Asn1 = forge.pkcs12.toPkcs12Asn1(keys.privateKey, cert, pfxPassphrase, {
    algorithm: '3des',
  });
  return Buffer.from(forge.asn1.toDer(p12Asn1).getBytes(), 'binary').toString('base64');
}

async function createSyntheticPdfBase64() {
  const pdfDoc = await PDFDocument.create();
  const page = pdfDoc.addPage([612, 792]);
  const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
  page.drawText('Sealhouse signing-flow smoke document', {
    x: 72,
    y: 700,
    size: 18,
    font,
    color: rgb(0.1, 0.1, 0.1),
  });
  page.drawText('Generated test data only. No customer content.', {
    x: 72,
    y: 672,
    size: 12,
    font,
    color: rgb(0.25, 0.25, 0.25),
  });
  page.drawRectangle({
    x: 72,
    y: 580,
    width: 220,
    height: 56,
    borderWidth: 1,
    borderColor: rgb(0.1, 0.4, 0.4),
  });
  page.drawText('Signature', {
    x: 82,
    y: 600,
    size: 11,
    font,
    color: rgb(0.1, 0.4, 0.4),
  });

  const bytes = await pdfDoc.save();
  return Buffer.from(bytes).toString('base64');
}

async function getExtendedUserByEmail(email) {
  const query = new Parse.Query('contracts_Users');
  query.equalTo('Email', email);
  query.include('UserId');
  query.include('TenantId');
  query.include('OrganizationId');
  return query.first({ useMasterKey: true });
}

async function createSignerContact(adminUser, tenantId) {
  const signerUser = new Parse.User();
  signerUser.set('username', 'signer.smoke@sealhouse.test');
  signerUser.set('email', 'signer.smoke@sealhouse.test');
  signerUser.set('password', smokePassword);
  signerUser.set('name', 'Smoke Signer');
  const signerParseUser = await signerUser.signUp(null, { useMasterKey: true });

  const contact = new Parse.Object('contracts_Contactbook');
  contact.set('Name', 'Smoke Signer');
  contact.set('Email', 'signer.smoke@sealhouse.test');
  contact.set('UserRole', 'contracts_Guest');
  contact.set('IsDeleted', false);
  contact.set('CreatedBy', adminUser);
  contact.set('UserId', signerParseUser);
  contact.set('TenantId', {
    __type: 'Pointer',
    className: 'partners_Tenant',
    objectId: tenantId,
  });
  return contact.save(null, { useMasterKey: true });
}

async function createSmokeDocument({ adminUser, extAdmin, signer, sourceUrl }) {
  const placeholder = {
    Role: 'signer',
    signerObjId: signer.id,
    signerPtr: {
      __type: 'Pointer',
      className: 'contracts_Contactbook',
      objectId: signer.id,
    },
    placeHolder: [
      {
        pageNumber: 1,
        pos: [
          {
            type: 'signature',
            xPosition: 72,
            yPosition: 580,
            Width: 220,
            Height: 56,
          },
        ],
      },
    ],
  };

  const doc = new Parse.Object('contracts_Document');
  doc.set('Name', 'Sealhouse Smoke Agreement');
  doc.set('URL', sourceUrl);
  doc.set('SignedUrl', '');
  doc.set('IsCompleted', false);
  doc.set('IsDeclined', false);
  doc.set('IsArchive', false);
  doc.set('IsEnableOTP', false);
  doc.set('IsSendMail', false);
  doc.set('NotifyOnSignatures', false);
  doc.set('TimeToCompleteDays', 15);
  doc.set('ExtUserPtr', extAdmin);
  doc.set('CreatedBy', adminUser);
  doc.set('Signers', [signer]);
  doc.set('Placeholders', [placeholder]);
  doc.set('AuditTrail', [
    {
      UserPtr: {
        __type: 'Pointer',
        className: 'contracts_Users',
        objectId: extAdmin.id,
      },
      Activity: 'Created',
      SignedOn: new Date(),
    },
  ]);

  return doc.save(null, { useMasterKey: true });
}

describe('Sealhouse signing-flow smoke', () => {
  let smokeDocId;

  beforeAll(() => {
    configureParseClient();
    process.env.PFX_BASE64 = createSmokePfxBase64();
    process.env.PASS_PHRASE = pfxPassphrase;
    fs.mkdirSync(path.join(process.cwd(), 'exports'), { recursive: true });
  });

  afterAll(() => {
    if (smokeDocId) {
      fs.rmSync(path.join(process.cwd(), 'exports', `signed_certificate_${smokeDocId}.pdf`), {
        force: true,
      });
    }
  });

  it(
    'creates an admin, uploads a synthetic PDF, places a signature field, and completes signing',
    async () => {
      const adminEmail = 'admin.smoke@sealhouse.test';
      const pdfBase64 = await createSyntheticPdfBase64();

      const setupResult = await Parse.Cloud.run('addadmin', {
        userDetails: {
          name: 'Smoke Admin',
          email: adminEmail,
          password: smokePassword,
          company: 'Sealhouse Smoke Lab',
          role: 'contracts_Admin',
          timezone: 'UTC',
        },
      });
      expect(setupResult.message).toBe('User sign up');

      const adminExists = await Parse.Cloud.run('checkadminexist');
      expect(adminExists).toBe('exist');

      const adminUser = await Parse.User.logIn(adminEmail, smokePassword);
      const adminSessionToken = adminUser.getSessionToken();
      const extAdmin = await getExtendedUserByEmail(adminEmail);
      expect(extAdmin.get('UserRole')).toBe('contracts_Admin');
      expect(extAdmin.get('OrganizationId')?.id).toBeDefined();

      const uploadResult = await Parse.Cloud.run(
        'savefile',
        {
          fileBase64: pdfBase64,
          fileName: 'sealhouse-smoke-agreement.pdf',
        },
        { sessionToken: adminSessionToken }
      );
      expect(uploadResult.url).toContain('/files/');

      const signer = await createSignerContact(adminUser, extAdmin.get('TenantId').id);
      const doc = await createSmokeDocument({
        adminUser,
        extAdmin,
        signer,
        sourceUrl: uploadResult.url,
      });
      smokeDocId = doc.id;

      const placed = doc.get('Placeholders')?.[0]?.placeHolder?.[0]?.pos?.[0];
      expect(placed.type).toBe('signature');
      expect(placed.Width).toBe(220);

      const signResult = await Parse.Cloud.run('signPdf', {
        docId: doc.id,
        userId: signer.id,
        pdfFile: pdfBase64,
        signature: smokeSignaturePng,
      });
      expect(signResult.status).toBe('success');
      expect(signResult.data).toContain('/files/');

      const signedDocQuery = new Parse.Query('contracts_Document');
      signedDocQuery.include('Signers');
      const signedDoc = await signedDocQuery.get(doc.id, { useMasterKey: true });
      expect(signedDoc.get('IsCompleted')).toBeTrue();
      expect(signedDoc.get('SignedUrl')).toContain('/files/');
      expect(signedDoc.get('DocumentHash')).toMatch(/^[a-f0-9]{64}$/);

      const signedAudit = signedDoc
        .get('AuditTrail')
        .find(
          entry =>
            (entry?.UserPtr?.objectId || entry?.UserPtr?.id) === signer.id &&
            entry?.Activity === 'Signed'
        );
      expect(signedAudit).toBeDefined();
    },
    1000 * 60 * 2
  );
});
