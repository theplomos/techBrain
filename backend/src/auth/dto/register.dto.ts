import { Transform } from 'class-transformer';
import {
  IsEmail,
  IsString,
  IsStrongPassword,
  Length,
  MaxLength,
} from 'class-validator';
import { normalizeEmail, trimString } from '../../common/normalizers';

export class RegisterDto {
  @IsEmail()
  @MaxLength(254)
  @Transform(({ value }) => normalizeEmail(value as unknown))
  email: string;

  @IsString()
  @Length(2, 150)
  @Transform(({ value }) => trimString(value as unknown))
  fullName: string;

  @IsString()
  @Length(8, 72)
  @IsStrongPassword({
    minLength: 8,
    minLowercase: 1,
    minUppercase: 1,
    minNumbers: 1,
    minSymbols: 0,
  })
  password: string;
}
