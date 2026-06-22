import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';

const projectRoot = 'D:\\Codex\\esignature\\src\\open-signature';
const dataRoot = 'D:\\Codex\\esignature\\data';
const serverRoot = path.join(projectRoot, 'apps', 'OpenSignServer');
const require = createRequire(path.join(serverRoot, 'index.js'));
const forge = require('node-forge');
const certDir = path.join(dataRoot, 'certs');
const envPath = path.join(projectRoot, 'apps', 'OpenSignServer', '.env');
const passphrase = 'sealhouse-local-dev';

fs.mkdirSync(certDir, { recursive: true });

const keys = forge.pki.rsa.generateKeyPair(2048);
const cert = forge.pki.createCertificate();
cert.publicKey = keys.publicKey;
cert.serialNumber = String(Date.now());
cert.validity.notBefore = new Date();
cert.validity.notAfter = new Date();
cert.validity.notAfter.setFullYear(cert.validity.notBefore.getFullYear() + 5);

const attrs = [
  { name: 'commonName', value: 'Sealhouse Local Development' },
  { name: 'organizationName', value: 'Sealhouse Local' },
  { shortName: 'OU', value: 'Development Only' },
];
cert.setSubject(attrs);
cert.setIssuer(attrs);
cert.setExtensions([
  { name: 'basicConstraints', cA: false },
  { name: 'keyUsage', digitalSignature: true, nonRepudiation: true },
  { name: 'extKeyUsage', codeSigning: true, emailProtection: true },
  { name: 'subjectKeyIdentifier' },
]);
cert.sign(keys.privateKey, forge.md.sha256.create());

const p12Asn1 = forge.pkcs12.toPkcs12Asn1(keys.privateKey, cert, passphrase, {
  algorithm: '3des',
});
const p12Der = forge.asn1.toDer(p12Asn1).getBytes();
const p12Buffer = Buffer.from(p12Der, 'binary');
const pfxPath = path.join(certDir, 'sealhouse-local-dev.p12');
fs.writeFileSync(pfxPath, p12Buffer);

const pfxBase64 = p12Buffer.toString('base64');
let env = fs.existsSync(envPath) ? fs.readFileSync(envPath, 'utf8') : '';
const setEnv = (text, key, value) => {
  const line = `${key}=${value}`;
  const pattern = new RegExp(`^${key}=.*$`, 'm');
  return pattern.test(text) ? text.replace(pattern, line) : `${text.trimEnd()}\n${line}\n`;
};

env = setEnv(env, 'PFX_BASE64', pfxBase64);
env = setEnv(env, 'PASS_PHRASE', passphrase);
fs.writeFileSync(envPath, env);

console.log(JSON.stringify({ pfxPath, envPath, passphrase }, null, 2));
