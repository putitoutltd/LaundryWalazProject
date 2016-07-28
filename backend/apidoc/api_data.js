define({ "api": [
  {
    "type": "post",
    "url": "/api/order/create",
    "title": "Create Order",
    "name": "CreateOrder",
    "group": "Orders",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": true,
            "field": "email",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": true,
            "field": "phone",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": true,
            "field": "first_name",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": true,
            "field": "last_name",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "location_id",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "address",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "access_token",
            "description": "<p>The dynamic token generated after successful login</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>datetime</p> ",
            "optional": false,
            "field": "pickup_time",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>datetime</p> ",
            "optional": false,
            "field": "dropoff_time",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": true,
            "field": "special_instructions",
            "description": ""
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns an array with user details if successful other wise failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/order_controller.php",
    "groupTitle": "Orders"
  },
  {
    "type": "post",
    "url": "/api/order/status",
    "title": "Order Status",
    "name": "OrderStatus",
    "group": "Orders",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "access_token",
            "description": "<p>The dynamic token generated after successful login</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns an array with user details if successful other wise failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/order_controller.php",
    "groupTitle": "Orders"
  },
  {
    "type": "get",
    "url": "/api/services/operating_areas",
    "title": "Operating Areas",
    "name": "OperatingAreas",
    "group": "Services",
    "version": "0.1.0",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns an array with operating areas list.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/service_controller.php",
    "groupTitle": "Services"
  },
  {
    "type": "get",
    "url": "/api/services/list",
    "title": "Services List",
    "name": "ServiceList",
    "group": "Services",
    "version": "0.1.0",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns an array with services list.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/service_controller.php",
    "groupTitle": "Services"
  },
  {
    "type": "post",
    "url": "/api/user/forget-password",
    "title": "Forget Password",
    "name": "ForgetPassword",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "email",
            "description": "<p>User's email to which the password should be sent.</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>It sends an email to the User with new password(and stores an sha256 encrypted password in the database) and returns an array with success or failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "put",
    "url": "/api/user/is_logged_in",
    "title": "Is Logged In",
    "name": "IsLoggedIn",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "access_token",
            "description": "<p>The token you receive if successfully login</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>It sends true if a user is logged in User with a notification and returns an array with success or failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "post",
    "url": "/api/user/login",
    "title": "Login",
    "name": "Login",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "email",
            "description": "<p>The email that was used to register</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "password",
            "description": "<p>User's password</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns an array with access token and user details if successful other wise failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "put",
    "url": "/api/user/logout",
    "title": "Logout",
    "name": "Logout",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "access_token",
            "description": "<p>The token you receive if successfully login</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns an array with success or failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "post",
    "url": "/api/user/register",
    "title": "Register new User",
    "name": "Register",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "email",
            "description": "<p>must be unique</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "password",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": true,
            "field": "location_id",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "phone",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "first_name",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "last_name",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": true,
            "field": "address",
            "description": ""
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns an array with user details if successful other wise failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "put",
    "url": "/api/user/reset-forgot-password",
    "title": "Reset Forgot Password",
    "name": "ResetForgotPassword",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "email",
            "description": "<p>Email address of the user for which the password is requested</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "pass_token",
            "description": "<p>Password token sent within the email</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "time_sent",
            "description": "<p>Time when the email was sent.</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "new_password",
            "description": "<p>User's new password.</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>It updates the password and sends an email to the User with a notification and returns an array with success or failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "put",
    "url": "/api/user/reset-password",
    "title": "Reset Password",
    "name": "ResetPassword",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "access_token",
            "description": "<p>The token you receive if successfully login</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "current_password",
            "description": "<p>User's current password with which the user has logged in.</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "new_password",
            "description": "<p>User's new password.</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>It updates the password and sends an email to the User with a notification and returns an array with success or failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "get",
    "url": "/api/user/send_area_request",
    "title": "Send Area Request",
    "name": "SendAreaRequest",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "area_name",
            "description": "<p>The name of the area to be requested</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "email",
            "description": "<p>Email of the person who is requesting</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns success or failure.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "get",
    "url": "/api/user/send_feedback",
    "title": "Send Feedback",
    "name": "SendFeedback",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "about",
            "description": "<p>The service for which the feedback is about</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "feedback",
            "description": "<p>The feedback from the user</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns success or failure.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "put",
    "url": "/api/user/update",
    "title": "Update User",
    "name": "Update",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "access_token",
            "description": "<p>The token you receive if successfully login</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "first_name",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "middle_name",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "last_name",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "country",
            "description": ""
          },
          {
            "group": "Parameter",
            "type": "<p>int</p> ",
            "optional": true,
            "field": "status",
            "description": "<p>e.g 1,2 ['1' =&gt; 'Active', '2' =&gt; 'Inactive','3' =&gt; 'Suspended','4' =&gt; 'Invited']</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": true,
            "field": "type",
            "description": "<p>currently supports only one type of user i.e. 1 ['1' =&gt; 'Normal',]</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "gender",
            "description": "<p>possible values : male, female</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>Returns an array containing updated values or failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "put",
    "url": "/api/user/profile",
    "title": "User Profile",
    "name": "UserProfile",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "access_token",
            "description": "<p>The token you receive if successfully login</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>int</p> ",
            "optional": false,
            "field": "user_id",
            "description": "<p>The id of the user for which the profile should be rendered.</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>it returns an array with user and children data  or failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  },
  {
    "type": "put",
    "url": "/api/user/verify-token",
    "title": "Verify Token",
    "name": "VerifyToken",
    "group": "Users",
    "version": "0.1.0",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "token",
            "description": "<p>token to be verified</p> "
          },
          {
            "group": "Parameter",
            "type": "<p>string</p> ",
            "optional": false,
            "field": "email",
            "description": "<p>email with which the user registered</p> "
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "<p>Array</p> ",
            "optional": false,
            "field": "response",
            "description": "<p>Containing success status or failure with message.</p> "
          }
        ]
      }
    },
    "filename": "D:/wamp/www/laundrywalaz/backend/app/controllers/user_controller.php",
    "groupTitle": "Users"
  }
] });