// epicfailure-api/src/shared-layer/services.ts

// This file imports and re-exports the services used in the application.
// It imports the CognitoService and DynamoDBService from their respective files
// and then re-exports them for use in other parts of the application.

import CognitoService from './services/CognitoService';
import DynamoDBService from './services/DynamoDBService';

export { CognitoService, DynamoDBService };