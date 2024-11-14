// epicfailure-api/src/handlers/get-all-failures/get-all-failures-handler.ts
// This file defines the AWS Lambda handler for retrieving all epic failure records from DynamoDB.
// It imports necessary services and models, and uses DynamoDBService to fetch all records from DynamoDB.

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBService } from '@shared-layer/services';
import { EpicFailure } from '@shared-layer/models';

const dynamoDBService = new DynamoDBService();

const getAllFailuresHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  console.log('Event: ', event);

  try {
    const epicFailures: EpicFailure[] = await dynamoDBService.getEpicFailures();
    return {
      statusCode: 200,
      body: JSON.stringify({ epicFailures }),
    };
  } catch (error) {
    console.error('Error getting epic failures:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to get epic failures', error: error.message }),
    };
  }
};

exports.handler = getAllFailuresHandler;