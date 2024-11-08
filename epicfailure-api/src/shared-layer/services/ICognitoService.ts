import { LoginData } from '@shared-layer/models';

export interface ICognitoService {
  signUp(email: string, password: string, name: string): Promise<void>;
  signIn(email: string, password: string): Promise<LoginData>;
}