// epicfailure-api/src/shared-layer/services/CognitoService.ts

// This file defines the CognitoService class, which implements the ICognitoService interface.
// The class provides methods for interacting with AWS Cognito, including user sign-up and sign-in.
// It uses the AWS SDK for JavaScript to communicate with the Cognito Identity Provider.

import { CognitoIdentityServiceProvider } from 'aws-sdk';

import {
  CognitoIdentityProviderClient,
  InitiateAuthCommand,
  InitiateAuthCommandInput,
  SignUpCommand,
  AdminGetUserCommand,
} from '@aws-sdk/client-cognito-identity-provider';

import { LoginData } from '@shared-layer/models';
import { ICognitoService } from './ICognitoService';

class CognitoService implements ICognitoService {
  private client: CognitoIdentityProviderClient;

  private userPoolId: string;
  private clientId: string;

  constructor() {
    this.client = new CognitoIdentityProviderClient({ region: process.env.AWS_REGION });

    this.userPoolId = process.env.USER_POOL_ID!;
    this.clientId = process.env.COGNITO_CLIENT_ID!;

  }

  async signUp(email: string, password: string, name: string): Promise<void> {
    const params: CognitoIdentityServiceProvider.SignUpRequest = {
      ClientId: this.clientId,
      Username: email,
      Password: password,
      UserAttributes: [
        {
          Name: 'email',
          Value: email,
        },
        {
          Name: 'name',
          Value: name,
        },
      ],
    };

    try {
      const command = new SignUpCommand(params);
      const response = await this.client.send(command);
      console.log('Sign up successful:', response);
    } catch (error) {
      console.error('Error signing up:', error);
      throw error;
    }
  }
  async signIn(email: string, password: string): Promise<LoginData> {
    const params: InitiateAuthCommandInput = {
      AuthFlow: 'USER_PASSWORD_AUTH',
      ClientId: this.clientId,
      AuthParameters: {
        USERNAME: email,
        PASSWORD: password,
      },
    };

    try {
      const command = new InitiateAuthCommand(params);
      const response = await this.client.send(command);
      console.log('Sign in successful:', response);

      // Fetch user attributes
      const userParams = {
        UserPoolId: this.userPoolId,
        Username: email,
      };
      const adminGetUserCommand = new AdminGetUserCommand(userParams);
      const userResponse = await this.client.send(adminGetUserCommand);
      console.log('User attributes fetched:', userResponse);

      return {
        email,
        name: userResponse.UserAttributes?.find((attr) => attr.Name === 'name')?.Value || '',
        idToken: response.AuthenticationResult?.IdToken || '',
      };
    } catch (error) {
      console.error('Error signing in:', error);
      throw error;
    }
  }

}

export default CognitoService;