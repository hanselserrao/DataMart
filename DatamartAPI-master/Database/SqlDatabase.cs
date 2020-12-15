using System;
using System.Collections.Generic;
using System.Collections;
using System.Data;
using System.Data.OleDb;
using System.Configuration;
using System.Data.SqlClient;

namespace DatamartAPI.Database
{
    public class SqlDatabase : IDatabase, IDisposable
    {
        #region "Private Variables"
        private SqlConnection _connection = null;
        #endregion

        #region "Constructor Methods"
        /// <summary>
        /// This constructor should be used for creation of the instance for the specified app settings connection name
        /// </summary>
        /// <param name="connectionName">App Setting's connection name</param>
        public SqlDatabase()
        {
            _connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Defaultconnection"].ConnectionString);
            _connection.Open();
        }


        #endregion

        public IDbConnection Connection
        {
            get { return _connection; }
        }

        public DataTable ExecuteDataTable(string commandText, CommandType commandType, ArrayList param)
        {
            DataSet ds = new DataSet();
            SqlCommand cmd = GetCommand(commandText, commandType, param);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

            if (ds != null && ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        public DataTable ExecuteDataTableSummerize(string commandText, CommandType commandType, ArrayList param)
        {
            DataSet ds = new DataSet();
            SqlCommand cmd = GetCommand(commandText, commandType, param);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

            if (ds != null && ds.Tables.Count > 0)
                return ds.Tables[0];
            else
                return null;
        }

        public DataSet ExecuteDataSet(string commandText, CommandType commandType, ArrayList param)
        {
            DataSet ds = new DataSet();
            SqlCommand cmd = GetCommand(commandText, commandType, param);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

            return ds;
        }

        public int ExecuteNonQuery(string commandText, CommandType commandType, ArrayList param)
        {
            DataSet ds = new DataSet();
            SqlCommand cmd = GetCommand(commandText, commandType, param);
            return cmd.ExecuteNonQuery();
        }

        public object ExecuteScaler(string commandText, CommandType commandType, ArrayList param)
        {
            SqlCommand cmd = GetCommand(commandText, commandType, param);
            return cmd.ExecuteScalar();
        }

        private SqlCommand GetCommand(string commandText, CommandType commandType, ArrayList param)
        {
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandText = commandText;
            cmd.CommandType = commandType;
            if (param != null)
            {
                foreach (System.Collections.Generic.KeyValuePair<string, string> para in param)
                {
                    cmd.Parameters.AddWithValue(para.Key, para.Value);
                }
            }

            return cmd;
        }

        public void Dispose()
        {
            //if (_connection.State == ConnectionState.Open)
            //    _connection.Close();

            //_connection = null;

            _connection.Dispose();
        }

    }
}