import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBService } from '@shared-layer/services';

const dynamoDBService = new DynamoDBService();

const deleteEpicFailureHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  console.log('Event: ', event);

  const { failureID } = JSON.parse(event.body || '{}');

  if (!failureID) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'failureID is required' }),
    };
  }

  try {
    await dynamoDBService.deleteEpicFailure(failureID);
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Epic failure deleted successfully' }),
    };
  } catch (error) {
    console.error('Error deleting epic failure:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to delete epic failure', error: error.message }),
    };
  }
};

exports.handler = deleteEpicFailureHandler;