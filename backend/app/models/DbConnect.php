<?php

/**
 * Handling database connection
 *
 * @author Muhammad Shahbaz <mohammadshahbax@mail.com>
 * @copyright (c) 2015, Putitout Solutions
 * 
 */
abstract class DbConnect
{

    protected static $conn = NULL;

    /**
     * Returns the mysqli Adapter object
     * 
     * @return Mysqli Object
     */
    function getConnection()
    {
        if (self::$conn == NULL) {
            self::$conn = $this->connect();
        }
        return self::$conn;
    }

    /**
     * Establishing database connection
     * @return database connection handler
     */
    function connect()
    {
        include_once dirname(__FILE__) . '/Config.php';

        try {
            $db_username = DB_USERNAME;
            $db_password = DB_PASSWORD;
            $db_host = DB_HOST;
            $db_name = DB_NAME;
            self::$conn = new PDO("mysql:host=$db_host;dbname=$db_name", $db_username, $db_password);
            self::$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            echo 'ERROR: ' . $e->getMessage();
        }

        // returing connection resource
        return self::$conn;
    }

    /**
     * 
     * @param type $table Datbase table name
     * @param type $data Dataset to save in database table
     * @return boolean returns the rows inserted or false 
     */
    function save($table, $data)
    {
        $bindArray = array();
        foreach ($data as $field_name => $field_value) {
            $fields[] = $field_name;
            $fieldsHolders[] = ":$field_name";
            $bindArray[":$field_name"] = $field_value;
        } 
        $fields = implode(",", $fields);
        $fieldsHolders = implode(",", $fieldsHolders);

        $query = "INSERT INTO $table  ($fields) VALUES ($fieldsHolders)";
        $statement = $this->getConnection()->prepare($query);

        try {
            $statement->execute($bindArray);
        } catch (PDOException $e) {
            echo '{"error":{"text":' . $e->getMessage() . '}}';
        }

        $mysql_insert_id = $this->getConnection()->lastInsertId();
        if ($mysql_insert_id > 0) {
            return $mysql_insert_id;
        } else {
            return false;
        }
    }

    /**
     * 
     * @param type $table Datbase table name
     * @param type $data Dataset to save in database table
     * @param type $where condition to update in database table
     * @return boolean returns the rows inserted or false 
     */
    function update($table, $data, $where = "", $bindParams = array())
    {
        foreach ($data as $field_name => $field_value) {
            $fields[] = "$field_name = :$field_name";
            $bindParams[":$field_name"] = isset($bindParams[":$field_name"]) ? $bindParams[":$field_name"] : $field_value;
        }

        $fields = implode(",", $fields);

        $query = "UPDATE " . $table . " SET " . $fields . " WHERE " . $where;
        $statement = $this->getConnection()->prepare($query);
        !empty($bindParams) ? $statement->execute($bindParams) : $statement->execute();
        $mysql_affected_rows = $statement->rowCount();

        if ($mysql_affected_rows > 0) {
            return ($mysql_affected_rows > 0 ? $mysql_affected_rows : true);
        } else {
            return false;
        }
    }

    /**
     * 
     * @param type $table Datbase table name
     * @param type $data Dataset to replace in database table
     * @return boolean returns the rows inserted or false 
     */
    function replace($table, $data)
    {
        foreach ($data as $field_name => $field_value) {
            $fields[] = " `" . $field_name . "` = '" . $field_value . "' ";
        }

        $fields = implode(",", $fields);

        $query = "REPLACE INTO " . $table . " SET " . $fields;

        $statement = $this->getConnection()->prepare($query);
        $statement->execute();
        $mysql_affected_rows = $statement->rowCount();

        if ($mysql_affected_rows > 0) {
            return $mysql_affected_rows;
        } else {
            return false;
        }
    }

    /**
     * 
     * @param type $table Database table name
     * @param type $where condition to delete record(s)
     * @return boolean returns the rows inserted or false
     */
    function delete($table, $where, $bindParams = array())
    {
        $query = "DELETE FROM " . $table . " WHERE " . $where;
        $statement = $this->getConnection()->prepare($query);
        !empty($bindParams) ? $statement->execute($bindParams) : $statement->execute();
        $mysql_affected_rows = $statement->rowCount();

        if ($mysql_affected_rows > 0) {
            return $mysql_affected_rows;
        } else {
            return false;
        }
    }

    /**
     * 
     * @param type $table Database table name
     * @param type $where condition to count record(s)
     * @return boolean returns the rows inserted or false
     */
    function countRows($table, $where, $bindParams = array())
    {
        $query = "SELECT count(*) FROM " . $table . " WHERE " . $where;
        $statement = $this->getConnection()->prepare($query);
        !empty($bindParams) ? $statement->execute($bindParams) : $statement->execute();
        $count = $statement->fetchColumn();

        if ($count > 0) {
            return $count;
        } else {
            return false;
        }
    }

    /**
     * 
     * @param type $query Query string to execute in database
     * @return type returns the query insertion status
     */
    public function runQuery($query, $bindParams = array())
    {
        $statement = $this->getConnection()->prepare($query);
        return !empty($bindParams) ? $statement->execute($bindParams) : $statement->execute();
    }

    public function getRow($query, $bindParams = array())
    {
        $statement = $this->getConnection()->prepare($query);
        !empty($bindParams) ? $statement->execute($bindParams) : $statement->execute();
        return $statement->fetch(PDO::FETCH_ASSOC);
    }

    public function getAll($query, $bindParams = array(),$fetchType = PDO::FETCH_ASSOC)
    {
        $statement = $this->getConnection()->prepare($query);
        !empty($bindParams) ? $statement->execute($bindParams) : $statement->execute();
        return $statement->fetchAll($fetchType);
    }

}
