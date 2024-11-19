// epicfailure-api/src/shared-layer/services/DynamoDBService.ts

// This file defines the DynamoDBService class, which implements the IDynamoDBService interface.
// The class provides methods for interacting with AWS DynamoDB, including adding, retrieving, and deleting epic failure records.
// It uses the AWS SDK for JavaScript to communicate with DynamoDB and the AWS SDK utilities for marshalling and unmarshalling data.

import { DynamoDBClient, PutItemCommand, DeleteItemCommand, ScanCommand } from '@aws-sdk/client-dynamodb';
import { marshall, unmarshall } from '@aws-sdk/util-dynamodb';
import { IDynamoDBService } from './IDynamoDBService';
import type { IEpicFailure } from '../models/EpicFailure';

class DynamoDBService implements IDynamoDBService {
  private client: DynamoDBClient;
  private static readonly NULL_PLACEHOLDER = 'NULL';

  constructor() {
    this.client = new DynamoDBClient({ region: process.env.AWS_REGION });
  }
  async addEpicFailure(failureID: string, taskAttempted: string, whyItFailed: string, lessonsLearned: string[]): Promise<void> {
    const params = {
      TableName: process.env.DYNAMODB_TABLE_NAME,
      Item: marshall({
        failureID,
        taskAttempted,
        whyItFailed,
        lessonsLearned,
      }),
    };

    const command = new PutItemCommand(params);
    await this.client.send(command);
  }

  async getEpicFailures(): Promise<IEpicFailure[]> {
    const params = {
      TableName: process.env.DYNAMODB_TABLE_NAME,
    };

    const command = new ScanCommand(params);
    const response = await this.client.send(command);

    return (response.Items || []).map((item) => unmarshall(item) as IEpicFailure);
  }
  
  async deleteEpicFailure(failureID: string): Promise<void> {
    const params = {
      TableName: process.env.DYNAMODB_TABLE_NAME,
      Key: { failureID: { S: failureID } },
    };

    const command = new DeleteItemCommand(params);
    await this.client.send(command);
  }
}

export default DynamoDBService;