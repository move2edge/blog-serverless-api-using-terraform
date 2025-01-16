// epicfailure-api/src/services/ICognitoService.ts

import { ILoginData } from '../models/LoginData';

// This file defines the ICognitoService interface, which specifies the methods for interacting with AWS Cognito.

export interface ICognitoService {
  signUp(email: string, password: string, name: string): Promise<void>;
  signIn(email: string, password: string): Promise<ILoginData>;
}
