// epicfailure-api/src/handlers/create-epic-failure-handler.ts

// This file defines the AWS Lambda handler for a dummy epic failure creation.
// It validates the request body against a schema and creates an epic failure object.

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import * as Joi from 'joi';

import EpicFailure, { IEpicFailure } from '../models/EpicFailure';

const epicFailureSchema = Joi.object<IEpicFailure>({
  failureID: Joi.string().required(),
  taskAttempted: Joi.string().required(),
  whyItFailed: Joi.string().required(),
  lessonsLearned: Joi.array().items(Joi.string()).required(),
});

const createEpicFailureHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  console.log('Event: ', event);

  // Parse the request body
  const requestBody = JSON.parse(event.body || '{}');

  // Validate the request body against the schema
  const { error, value } = epicFailureSchema.validate(requestBody);
  if (error) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Invalid request body', error: error.details[0].message }),
    };
  }

  const { failureID, taskAttempted, whyItFailed, lessonsLearned } = value as IEpicFailure;

  const epicFailure = new EpicFailure(failureID, taskAttempted, whyItFailed, lessonsLearned);

  console.log('Creating epic failure:', epicFailure);
  return {
    statusCode: 201,
    body: JSON.stringify({ message: 'Epic failure created successfully', epicFailure }),
  };
};

exports.handler = createEpicFailureHandler;
