import { IsString, Length } from 'class-validator';

export class RefreshTokenDto {
  @IsString()
  @Length(40, 200)
  refreshToken: string;
}

export class ExchangeCodeDto {
  @IsString()
  @Length(40, 200)
  code: string;
}
