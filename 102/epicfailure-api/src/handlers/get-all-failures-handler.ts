// epicfailure-api/src/handlers/get-all-failures-handler.ts

// This file defines the AWS Lambda handler for retrieving all epic failure records from DynamoDB.
// It imports necessary services and models, and uses DynamoDBService to fetch all records from DynamoDB.

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import type { IEpicFailure } from '../models/EpicFailure';
import DynamoDBService from '../services/DynamoDBService';

const dynamoDBService = new DynamoDBService();

const getAllFailuresHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  console.log('Event: ', event);

  try {
    const epicFailures: IEpicFailure[] = await dynamoDBService.getEpicFailures();
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