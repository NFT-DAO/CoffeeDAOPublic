import { Application, Router, oakCors } from './deps.ts';
import { mintNFT } from './mint.ts';

const app = new Application();
app.use(oakCors());
const router = new Router();
console.log("starting app");
router.post('/mint', async (context) => {
    const { witness, tx } = await context.request.body().value;
    const result = await mintNFT(witness, tx);
    context.response.body = result;
});
app.use(router.routes());
app.use(router.allowedMethods());
await app.listen({ port: 8000 });
