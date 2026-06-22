import { startParseServer, stopParseServer, dropDB, cleanupTestFiles } from './utils/test-runner.js';
beforeAll(
  async () => {
    await startParseServer();
  },
  1000 * 60 * 2
);

afterAll(
  async () => {
    await dropDB();
    await stopParseServer();
    await cleanupTestFiles();
  },
  1000 * 60 * 2
);
