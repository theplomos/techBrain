import {
  ArrayNotEmpty,
  IsArray,
  IsBoolean,
  IsEnum,
  IsOptional,
} from 'class-validator';
import { Role } from '@prisma/client';

export class UpdateAccessDto {
  @IsOptional()
  @IsArray()
  @ArrayNotEmpty()
  @IsEnum(Role, { each: true })
  roles?: Role[];

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}
