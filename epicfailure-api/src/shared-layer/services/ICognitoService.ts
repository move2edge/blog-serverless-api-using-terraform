// epicfailure-api/src/shared-layer/services/ICognitoService.ts

// This file defines the ICognitoService interface, which specifies the methods for interacting with AWS Cognito.

import { LoginData } from '@shared-layer/models';

export interface ICognitoService {
  signUp(email: string, password: string, name: string): Promise<void>;
  signIn(email: string, password: string): Promise<LoginData>;
}