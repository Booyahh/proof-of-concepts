**_requirements_**

```bash
node --version
npm i mysql
```

**_sqlConnection.js_**

```js
var mysql = require("mysql");

const sqlConnection = (credentials, query, callback) => {
  let connection = mysql.createConnection(credentials);
  connection.query(query, (error, results) => {
    if (error) {
      callback(
        {
          code: error.code,
          errno: error.errno,
          sqlMessage: error.sqlMessage,
          sqlState: error.sqlState,
        },
        null
      );
    } else {
      callback(null, { results, fields });
    }
  });
  connection.end();
};

module.exports = sqlConnection;



```

**_mysqlCredentials.js_**

```js
var readCredentials = {
  host: "172.17.0.3",
  user: "root",
  password: ".",
  database: "ode",
};

var writeCredentials = {
  host: "172.17.0.3",
  user: "root",
  password: ".",
  database: "ode",
};

module.exports = {
  readCredentials,
  writeCredentials,
};
```

**_support.js_**

```js
let sqlConnection = require("./sqlConnection");
let credentials = require("./mysqlCredentials");

var query = "SELECT 1 + 1 AS solution";
sqlConnection(credentials.readCredentials, query, (err, results) => {
  if (err) {
    console.log(err);
  } else {
    console.log(results);
  }
});
```
