import { Application, Router, oakCors } from './deps.ts';
import { getPrd } from './addr.ts';
import { getZip } from './zip.ts';

const app = new Application();
app.use(oakCors());
const router = new Router();
console.log("starting app");
router.post('/ac', async (context) => {
    const { entry } = await context.request.body().value;
    const result = await getPrd(entry);
    context.response.body = result;
});
router.post('/zip', async (context) => {
    const { street, city, state } = await context.request.body().value
    const result = await getZip(street, city, state);
    context.response.body = result;
});
app.use(router.routes());
app.use(router.allowedMethods());
await app.listen({ port: 8000 });
