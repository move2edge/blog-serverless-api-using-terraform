// epicfailure-api/src/handlers/create-epic-failure-handler.ts

// This file defines the AWS Lambda handler for creating an epic failure record in DynamoDB.
// It imports necessary services and models, parses the incoming request, validates the input,
// creates an EpicFailure object, and uses DynamoDBService to store the record in DynamoDB.

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import * as Joi from 'joi';

import EpicFailure, { IEpicFailure } from '../models/EpicFailure';
import DynamoDBService from '../services/DynamoDBService';

const dynamoDBService = new DynamoDBService();

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

  try {
    await dynamoDBService.addEpicFailure(epicFailure.failureID, epicFailure.taskAttempted, epicFailure.whyItFailed, epicFailure.lessonsLearned);
    return {
      statusCode: 201,
      body: JSON.stringify({ message: 'Epic failure created successfully', epicFailure }),
    };
  } catch (error) {
    console.error('Error creating epic failure:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to create epic failure', error: error.message }),
    };
  }
};

exports.handler = createEpicFailureHandler;