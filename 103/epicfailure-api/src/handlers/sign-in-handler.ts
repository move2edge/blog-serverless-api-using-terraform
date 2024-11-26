// epicfailure-api/src/handlers/sign-in/sign-in-handler.ts

// This file defines the AWS Lambda handler for user sign-in using Cognito.
// It imports necessary services and libraries, validates the incoming request,
// and uses CognitoService to authenticate the user with the provided email and password.

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import * as Joi from 'joi';
import CognitoService from 'src/services/CognitoService';

const cognitoService = new CognitoService();

const signInSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});

const signInHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  const { email, password } = JSON.parse(event.body || '{}');

  const { error } = signInSchema.validate({ email, password });
  if (error) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Invalid request body', error: error.details[0].message }),
    };
  }

  try {
    const loginData = await cognitoService.signIn(email, password);
    return {
      statusCode: 200,
      body: JSON.stringify(loginData),
    };
  } catch (error) {
    console.log(error);
    return {
      statusCode: 401,
      body: JSON.stringify({ message: 'Unauthorized' }),
    };
  }
};

exports.handler = signInHandler;