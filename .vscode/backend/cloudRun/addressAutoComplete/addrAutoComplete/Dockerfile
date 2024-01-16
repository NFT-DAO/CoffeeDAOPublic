FROM denoland/deno:latest
WORKDIR /app
COPY . ./
EXPOSE 8000
CMD ["run", "--allow-env", "--allow-read", "--allow-net", "index.ts"]