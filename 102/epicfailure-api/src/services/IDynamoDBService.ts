// epicfailure-api/src/shared-layer/services/IDynamoDBService.ts
// This file defines the IDynamoDBService interface, which specifies the methods for interacting with AWS DynamoDB.

import type { IEpicFailure } from "src/models/EpicFailure";

export interface IDynamoDBService {
    addEpicFailure(failureID: string, taskAttempted: string, whyItFailed: string, lessonsLearned: string[]): Promise<void>;
    getEpicFailures(): Promise<IEpicFailure[]>;
    deleteEpicFailure(failureID: string): Promise<void>;
  }