import { Transform } from 'class-transformer';
import { IsEmail, IsString, Length, MaxLength } from 'class-validator';
import { normalizeEmail } from '../../common/normalizers';

export class LoginDto {
  @IsEmail()
  @MaxLength(254)
  @Transform(({ value }) => normalizeEmail(value as unknown))
  email: string;

  @IsString()
  @Length(1, 72)
  password: string;
}
