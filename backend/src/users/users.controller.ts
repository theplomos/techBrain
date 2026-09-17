import {
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Patch,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { Role } from '@prisma/client';
import { Auth } from '../auth/decorators/auth.decorator';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UpdateAccessDto } from './dto/update-access.dto';
import { PublicUser } from './user.types';
import { UsersService } from './users.service';

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  @Auth()
  getProfile(@CurrentUser() user: PublicUser) {
    return user;
  }

  @Patch('me')
  @Auth()
  updateProfile(
    @CurrentUser() user: PublicUser,
    @Body() dto: UpdateProfileDto,
  ) {
    return this.usersService.updateProfile(user.id, dto);
  }

  @Get()
  @Auth(Role.admin)
  findAll() {
    return this.usersService.findAll();
  }

  @Patch(':id/access')
  @Auth(Role.admin)
  updateAccess(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateAccessDto,
  ) {
    return this.usersService.updateAccess(id, dto);
  }
}
