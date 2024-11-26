// epicfailure-api/src/models/EpicFailure.ts

// This file defines the EpicFailure class, which represents a record of an epic failure.

export interface IEpicFailure {
  failureID: string;
  taskAttempted: string;
  whyItFailed: string;
  lessonsLearned: string[];
}

export default class EpicFailure implements IEpicFailure {
  failureID: string;
  taskAttempted: string;
  whyItFailed: string;
  lessonsLearned: string[];

  constructor(failureID: string, taskAttempted: string, whyItFailed: string, lessonsLearned: string[]) {
    this.failureID = failureID;
    this.taskAttempted = taskAttempted;
    this.whyItFailed = whyItFailed;
    this.lessonsLearned = lessonsLearned;
  }
}
