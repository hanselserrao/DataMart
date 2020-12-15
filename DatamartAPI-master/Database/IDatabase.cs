using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Collections;

namespace DatamartAPI.Database
{
    public interface IDatabase : IDisposable
    {
        object ExecuteScaler(string commandText, CommandType commandType, ArrayList param);
        DataTable ExecuteDataTable(string commandText, CommandType commandType, ArrayList param);
        DataTable ExecuteDataTableSummerize(string commandText, CommandType commandType, ArrayList param);
        DataSet ExecuteDataSet(string commandText, CommandType commandType, ArrayList param);
        int ExecuteNonQuery(string commandText, CommandType commandType, ArrayList param);

        IDbConnection Connection { get; }
    }
}