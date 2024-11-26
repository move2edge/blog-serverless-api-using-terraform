// epicfailure-api/src/shared-layer/services/IDynamoDBService.ts

// This file defines the IDynamoDBService interface, which specifies the methods for interacting with AWS DynamoDB.

import { EpicFailure } from "@shared-layer/models";

export interface IDynamoDBService {
    addEpicFailure(failureID: string, taskAttempted: string, whyItFailed: string, lessonsLearned: string[]): Promise<void>;
    getEpicFailures(): Promise<EpicFailure[]>;
    deleteEpicFailure(failureID: string): Promise<void>;
  }