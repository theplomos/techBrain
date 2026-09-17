import { IsString, IsStrongPassword, Length } from 'class-validator';

export class ChangePasswordDto {
  @IsString()
  @Length(1, 72)
  currentPassword: string;

  @IsString()
  @Length(8, 72)
  @IsStrongPassword({
    minLength: 8,
    minLowercase: 1,
    minUppercase: 1,
    minNumbers: 1,
    minSymbols: 0,
  })
  newPassword: string;
}
