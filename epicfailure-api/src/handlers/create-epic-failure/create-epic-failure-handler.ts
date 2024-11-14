// epicfailure-api/src/handlers/create-epic-failure/create-epic-failure-handler.ts
// This file defines the AWS Lambda handler for creating an epic failure record in DynamoDB.
// It imports necessary services and models, parses the incoming request, validates the input,
// creates an EpicFailure object, and uses DynamoDBService to store the record in DynamoDB.

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBService } from '@shared-layer/services';
import { EpicFailure } from '@shared-layer/models';

const dynamoDBService = new DynamoDBService();

const createEpicFailureHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  console.log('Event: ', event);

  // Parse the request body
  const requestBody = JSON.parse(event.body || '{}');
  const { failureID, taskAttempted, whyItFailed, lessonsLearned } = requestBody;

  if (!failureID || !taskAttempted || !whyItFailed || !lessonsLearned) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'All fields are required' }),
    };
  }

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