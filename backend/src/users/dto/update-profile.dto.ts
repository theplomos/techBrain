import { Transform } from 'class-transformer';
import {
  IsOptional,
  IsString,
  IsUrl,
  Length,
  MaxLength,
} from 'class-validator';
import { trimString } from '../../common/normalizers';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @Length(2, 150)
  @Transform(({ value }) => trimString(value as unknown))
  fullName?: string;

  @IsOptional()
  @IsUrl({ require_protocol: true })
  @MaxLength(2048)
  avatarUrl?: string;
}
