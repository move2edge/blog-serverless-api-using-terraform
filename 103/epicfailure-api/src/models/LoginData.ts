// epicfailure-api/src/models/LoginData.ts

// This file defines the LoginData class, which represents the data returned after a successful user login.

export interface ILoginData {
  idToken: string;
  name: string;
  email: string;
}

export default class LoginData implements ILoginData {
  idToken: string;
  name: string;
  email: string;
}