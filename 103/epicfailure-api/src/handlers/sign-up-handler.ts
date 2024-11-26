// epicfailure-api/src/handlers/sign-up/sign-up-handler.ts

// This file defines the AWS Lambda handler for user sign-up using Cognito.
// It imports necessary services and libraries, validates the incoming request,
// and uses CognitoService to register the user with the provided email, password, and name.

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import * as Joi from 'joi';
import CognitoService from 'src/services/CognitoService';

const cognitoService = new CognitoService();

const signUpSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string()
    .min(8)
    .required()
    .custom((value, helpers) => {
      if (!/[a-z]/.test(value)) {
        return helpers.error('any.custom', { message: 'Password must contain at least one lowercase letter' });
      }
      if (!/[A-Z]/.test(value)) {
        return helpers.error('any.custom', { message: 'Password must contain at least one uppercase letter' });
      }
      if (!/\d/.test(value)) {
        return helpers.error('any.custom', { message: 'Password must contain at least one number' });
      }
      if (!/[@$!%*?&]/.test(value)) {
        return helpers.error('any.custom', { message: 'Password must contain at least one special character' });
      }
      return value;
    }),
  name: Joi.string().required(),
});

const signUpHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const { email, password, name } = JSON.parse(event.body || '{}');

  const { error } = signUpSchema.validate({ email, password, name });
  if (error) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Invalid request body', error: error.details[0].message }),
    };
  }

  try {
    await cognitoService.signUp(email, password, name);
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Sign up successful' }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Sign up failed', error: error.message }),
    };
  }
};

exports.handler = signUpHandler;