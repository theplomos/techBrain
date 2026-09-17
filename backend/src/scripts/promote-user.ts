import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module';
import { UsersService } from '../users/users.service';

async function promoteUser() {
  const email = process.argv[2]?.trim().toLowerCase();
  if (!email)
    throw new Error('Uso: npm run user:promote -- usuario@correo.com');

  const app = await NestFactory.createApplicationContext(AppModule, {
    logger: ['error', 'warn'],
  });
  try {
    const user = await app.get(UsersService).promoteByEmail(email);
    console.log(`${user.email} ahora tiene el rol admin`);
  } finally {
    await app.close();
  }
}

void promoteUser();
