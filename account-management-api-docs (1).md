# Account Management API Documentation

## Overview
The Account Management API provides endpoints for managing user accounts, specifically for resetting passwords and unlocking user accounts. This API requires authentication and specific authorization policies for each operation.

## Base URL
```
/api/AccountManagement
```

## Authentication
The API is exposed through Apinizer as a gateway service. Clients will need to use Basic Authentication when making requests to Apinizer.

### Client Authentication Flow:
1. Clients connect to Apinizer using Basic Authentication (username/password)
2. Apinizer validates the client credentials
3. The service then uses a service account to obtain a JWT token
4. This token is used to authenticate with the target Account Management API
5. All subsequent calls to the target API are made using the obtained JWT Bearer token

### Basic Authentication Format:
```
Authorization: Basic {base64(username:password)}
```

**Note:** Clients should only implement the Basic Authentication part. The JWT token acquisition and usage is handled internally by Apinizer and the service implementation.

## Endpoints

### Reset User Password
Resets a user's password based on the provided information.

**URL:** `/api/AccountManagement/Reset`

**Method:** `POST`

**Authorization Required:** `resetuserpassword` policy

**Request Body:**
```json
{
  "Username": "string",
  "TelephoneNumber": "string",
  "ChangePasswordNextLogon": boolean,
  "IsUserNonTei": boolean
}
```

**Parameters:**
| Field | Type | Description |
|-------|------|-------------|
| Username | string | The username of the account whose password will be reset |
| TelephoneNumber | string | The telephone number associated with the account |
| ChangePasswordNextLogon | boolean | Whether the user should be required to change their password at next logon |
| IsUserNonTei | boolean | Indicates if the user is a non-TEI user |

**Response:**
- **Status Code:** 200 OK
- No response body is returned for successful operations

**Example Request:**
```json
POST /api/AccountManagement/Reset HTTP/1.1
Authorization: Basic {base64_encoded_credentials}
Content-Type: application/json

{
  "Username": "john.doe",
  "TelephoneNumber": "+1234567890",
  "ChangePasswordNextLogon": true,
  "IsUserNonTei": false
}
```

**Note:** Replace `{base64_encoded_credentials}` with the Base64-encoded string of `username:password`

### Unlock User Account
Unlocks a user account that has been locked due to multiple failed login attempts or administrative action.

**URL:** `/api/AccountManagement/Unlock`

**Method:** `POST`

**Authorization Required:** `resetuserpassword` policy

**Request Body:**
```json
{
  "UserName": "string"
}
```

**Parameters:**
| Field | Type | Description |
|-------|------|-------------|
| UserName | string | The username of the account to be unlocked |

**Response:**
- **Status Code:** 200 OK
- No response body is returned for successful operations

**Example Request:**
```json
POST /api/AccountManagement/Unlock HTTP/1.1
Authorization: Basic {base64_encoded_credentials}
Content-Type: application/json

{
  "UserName": "john.doe"
}
```

**Note:** Replace `{base64_encoded_credentials}` with the Base64-encoded string of `username:password`

## Error Handling
The API returns standard HTTP status codes to indicate the success or failure of requests:

- **400 Bad Request:** The request was invalid or cannot be processed
- **401 Unauthorized:** Authentication is required or the provided credentials are invalid
- **403 Forbidden:** The authenticated user does not have the required permissions
- **500 Internal Server Error:** An unexpected error occurred on the server

## Technical Notes
- The API is built on ASP.NET Core and uses the Volo.Abp framework
- Authorization is policy-based, requiring specific permissions for each endpoint
- Both endpoints delegate to an underlying `IPasswordManagementService` that implements the actual business logic
- The API follows RESTful principles with appropriate HTTP methods for each operation

## Implementation Dependencies
- BtUtilities.Service.SystemManagement.Password
- Microsoft.AspNetCore.Authorization
- Microsoft.AspNetCore.Mvc
- Volo.Abp.AspNetCore.Mvc
