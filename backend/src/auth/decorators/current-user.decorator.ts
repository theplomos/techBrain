import {
  createParamDecorator,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { PublicUser } from '../../users/user.types';

export const CurrentUser = createParamDecorator(
  (_data: unknown, context: ExecutionContext): PublicUser => {
    const request = context.switchToHttp().getRequest<{ user?: PublicUser }>();
    if (!request.user) throw new UnauthorizedException();
    return request.user;
  },
);
