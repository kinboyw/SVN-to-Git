# 用LinqPad 快速开发C#代码

用 VisualStudio 写 C# 代码时，常规的步骤是

1. 启动 VisualStudio；
2. 新建项目，选择项目类型，初始化项目模板；
3. 在模板中添加项目引用，编写代码，编译项目；
4. 运行编译结果；

通常我们在第 1、2 两步上就会花上一到两分钟时间，对于 VS 这种超重型 IDE 来说，这是不可避免的。

当我们希望像写 C# 能够像 JS 或者 Python 代码一样，打开一个 Notepad 就可以开始编写，按下 F5 就可以直接运行，而且方便地打印运行结果的时候，就该放下 VisualStudio 让 LinqPad 上场了。

LinqPad 编写的代码文件后缀是 `.linq` ，既可以在 LinqPad 编辑器中编写，运行，调试，也可以在代码稳定后使用 LinqPad 提供的命令行工具来让 `.linq` 文件运行在生产 环境中，效率与 VisualStudio 编译输出的二进制无异，因为当你运行 LinqPad 中的 C# 代码时，LinqPad 也在后台完成了编译工作，只是这部分工作是自动完成的，用户并感觉不到。



上海青浦 Scada 数据接口轮询持久化服务代码备份，在LinqPad中运行。

```csharp
void Main()
{
	// construct a scheduler factory
	ISchedulerFactory schedFact = new StdSchedulerFactory();

	// get a scheduler
	IScheduler sched = schedFact.GetScheduler();
	sched.Start();

	IJobDetail job = JobBuilder.Create<LoggingJob>()
		.WithIdentity("myJob", "group1")
		.Build();

	ITrigger trigger = TriggerBuilder.Create()
		.WithIdentity("trigger2", "group1")
	.StartNow()
	.WithSchedule(SimpleScheduleBuilder
	.RepeatMinutelyForever()
	.WithIntervalInMinutes(5)
	.RepeatForever())
	.Build();

	sched.ScheduleJob(job, trigger);
}

// Define other methods and classes here
[PersistJobDataAfterExecution]
[DisallowConcurrentExecution]
public class LoggingJob : IJob
{
	public void Execute(IJobExecutionContext context)
	{
		var data = GetData();
		var obj = JsonConvert.DeserializeObject<Response>(data);
		var code = obj.code;
		var msg = obj.msg;
		var SensorData = obj.Data;

		if (code != "200")
		{
			Console.WriteLine($"数据查询错误！code：{code},msg：{msg}");
			return;
		}

		CreateProcedures();

		var effectiveData = SensorData.Where(o => o.TempTime != null);
		var effectiveData1 = GetSensorIDs(effectiveData);
		var effectiveData2 = GetBaseID(effectiveData);

		InsertSensorDataAsync(effectiveData1);
		InsertPumpDataAsync(effectiveData2);
		return;

	}

	private IEnumerable<Data> GetBaseID(IEnumerable<Data> effectiveData)
	{
		var sql = $@"
		select jz.id BaseID ,pa.ID ParamID,p.pcode from Pump p 
		inner join PumpJZ jz on p.id = jz.PumpId
		left join PumpAlarmParam pa on jz.id = pa.pumpJZID";
		var db = new RobotDBHelper(dbType, connString);
		var tmp = db.ExecuteDataSet(sql, out var err);
		if (!string.IsNullOrEmpty(err))
		{
			Console.WriteLine($"数据查询出错！err：{err}");
			return null;
		}
		var rows = tmp.Tables[0].Rows.Cast<DataRow>();
		Parallel.ForEach(effectiveData, item =>
		{
			if (tmp != null && tmp.Tables.Count > 0 && tmp.Tables[0].Rows != null)
			{

				var row = rows.Where(o => o["pcode"].ToString() == item.ID.ToUpper())?.Distinct()?.FirstOrDefault() ?? null;
				if (row == null)
				{
					Console.WriteLine($"pump表中查不到对应的pcode！ID:{item.ID}");
					return;
				}
				item.BaseID = row["BaseID"].ToString();
				item.ParamID = row["ParamID"].ToString();
			}
		});
		return effectiveData;
	}

	private IEnumerable<Data> GetSensorIDs(IEnumerable<Data> effectiveData)
	{
		var sql = $@"
		select se.id,se.name,right(se.code,1) code,StationNo from SCADA_Station st 
		left join SCADA_Sensor se 
		on st.id = se.StationID ";
		var db = new RobotDBHelper(dbType, connString);
		var tmp = db.ExecuteDataSet(sql, out var err);
		if (!string.IsNullOrEmpty(err))
		{
			Console.WriteLine($"数据查询出错！err：{err}");
			return null;
		}
		var rowss = tmp.Tables[0].Rows.Cast<DataRow>();
		Parallel.ForEach(effectiveData, item =>
		{
			if (tmp != null && tmp.Tables.Count > 0 && tmp.Tables[0].Rows != null)
			{
				var rows = rowss.Where(o => o["StationNo"].ToString() == item.ID.ToUpper())?.Distinct() ?? null;
				if (rows == null)
				{
					Console.WriteLine($"Station表中查不到对应的StationNo！ID：{item.ID}");
					return;
				}

				foreach (DataRow row in rows)
				{
					//var Name = row["Name"].ToString();
					var Code = row["code"].ToString();
					var ID = row["ID"].ToString();

					switch (Code)
					{
						case "1"://"出水压力":
							item.OutID = ID; break;
						case "2"://"进水压力":
							item.InID = ID; break;
						case "3"://"状态":
							item.StatusID = ID; break;
						default: break;
					}

				}
			}
		});
		return effectiveData;
	}

	void InsertPumpDataAsync(IEnumerable<Data> effectiveData2)
	{
		Task.Factory.StartNew(() =>
		{
			Parallel.ForEach(effectiveData2, item =>
			{
				if (item.BaseID == null)
				{
					Console.WriteLine($"未查到对应的BaseID! StationNo: {item.ID}");
					return;
				}
				var tname_pumphis = "PumpHisData";
				var tname_pumpalarm = "PumpAlarmHistory";
				var pname_pumpreal = "MergePumpRealData";
				var pname_pumpalarm = "MergePumpAlarmTimely";

				var sqls = new List<string>{
				$@"EXECUTE {pname_pumpreal} '{item.BaseID}','{item.FOnline}','{item.F41006}','{item.F41007}','{item.TempTime}'",
				$@"insert into {tname_pumphis} (BASEID,F40009,F40014,FCreateDate,TempTime) values ('{item.BaseID}','{item.F41006}','{item.F41007}','{item.TempTime}','{item.TempTime}')"
			};
				if (item.FOnline == 0)
				{
					sqls.Add($@"EXECUTE {pname_pumpalarm} '{item.BaseID}',{item.ParamID},'设备离线','{item.TempTime}'");
					sqls.Add($@"insert into {tname_pumpalarm} (PumpJZID,ParamID,Tips,FBeginAlarmTime) values ('{item.BaseID}',{item.ParamID},'设备离线','{item.TempTime}')");
				}
				foreach (var sql in sqls)
				{
					var db = new RobotDBHelper(dbType, connString);
					sql.Dump();
					db.ExecuteNonQuery(sql, out var err);
					if (!string.IsNullOrEmpty(err))
					{
						Console.WriteLine($"插入数据库出错！err: {err}");
						continue;
					}
				}
			});
		});
	}

	void InsertSensorDataAsync(IEnumerable<Data> effectiveData)
	{
		Task.Factory.StartNew(() =>
		{
			Parallel.ForEach(effectiveData, item =>
			{
				if (item.InID == null || item.OutID == null || item.StatusID == null)
				{
					Console.WriteLine($"查不到对应的SensorID！进水压力:{item.InID},出水压力:{item.OutID},状态:{item.StatusID}");
					Console.WriteLine($"StationID:{item.ID}");
					return;
				}
				var tname_rt = "SCADA_SensorRealTime";
				var pname_rt = "MergeScada_sensorRealTime";
				var tname_his = "SCADA_SensorHistory";
				var sqls = new string[] {
			//实时表
			
			#region merge into
//			$@"merge into SCADA_SensorRealTime as Target 
//			using(values 
//			('{item.InID}',{item.F41006},'{item.TempTime}'),
//			('{item.OutID}',{item.F41007},'{item.TempTime}'),
//			('{item.StatusID}',{item.FOnline},'{item.TempTime}')) as Source (SensorID,LastValue,LastTime)
//			on Target.SensorID = Source.SensorID
//			when matched THEN
//			UPDATE set LastValue = source.lastvalue,
//					 LastTime = source.lasttime
//			when not matched by Target then 
//			insert (SensorID,LastValue,LastTime) VALUES (source.Sensorid,source.lastvalue,source.lasttime);",
			#endregion
			
			$@"EXECUTE {pname_rt} '{item.InID}',{item.F41006},'{item.TempTime}'",
			$@"EXECUTE {pname_rt} '{item.OutID}',{item.F41007},'{item.TempTime}'",
			$@"EXECUTE {pname_rt} '{item.StatusID}',{item.FOnline},'{item.TempTime}'",
			//历史表
			$@"insert into {tname_his} (SensorID,PV,PT) values ('{item.InID}',{item.F41006},'{item.TempTime}')",
			$@"insert into {tname_his} (SensorID,PV,PT) values ('{item.OutID}',{item.F41007},'{item.TempTime}')",
			$@"insert into {tname_his} (SensorID,PV,PT) values ('{item.StatusID}',{item.FOnline},'{item.TempTime}')",
				};
				foreach (var sql in sqls)
				{
					var db = new RobotDBHelper(dbType, connString);
					sql.Dump();
					db.ExecuteNonQuery(sql, out var err);
					if (!string.IsNullOrEmpty(err))
					{
						Console.WriteLine($"插入数据库出错！err: {err}");
						continue;
					}
				}
			});
		});

	}



	private static readonly HttpClient client = new HttpClient();
	string tokenUrl = "https://new.s-water.cn/App/GetAccessToken";
	string appKey = "34h3rj3ri3jrt5y778934t5yfg3333h4h";
	string appSecret = "45tnn5juyojgn3rn3fnn3t5j4to3fn6y64p3";
	string dataUrl = "https://new.s-water.cn/App/GetData";
	string configUrl = "https://xyys.wohitech.com/Cityinterface/rest/services/OMS.svc/S_GetDataBaseConfig?_version=9999";

	public static Token lastToken = new Token();
	public static string token = "9f50a500-ccb5-4ea4-b086-829089095ae3";
	public static string expiretime = "2018-09-28 13:12:54";

	public string dbType = "SQLSERVER";
	private static string _connString = "";
	public string connString
	{
		get
		{
			if (_connString == "")
			{
				var responseString = client.GetStringAsync(configUrl);
				var config = JsonConvert.DeserializeObject<Config>(responseString.Result);
				_connString = $"Data Source=\"{config.ip}\";Initial Catalog=\"{config.dbName}\";User Id=\"{config.userName}\";Password=\"{config.passWord}\";";
			}
			return _connString;
		}
	}

	public class Data
	{
		public string ID { get; set; }
		public string TempTime { get; set; }
		public int FOnline { get; set; }
		public string F41006 { get; set; }
		public string F41007 { get; set; }
		public string InID { get; set; }
		public string OutID { get; set; }
		public string StatusID { get; set; }
		public string BaseID { get; set; }
		public string ParamID { get; set; }
	}
	public class Response
	{
		public string code { get; set; }
		public string msg { get; set; }
		public Data[] Data;
	}
	public class TokenResponse
	{
		public string code { get; set; }
		public string msg { get; set; }
		public Token data { get; set; }
	}
	public class Token
	{
		public string accessToken { get; set; }
		public DateTime expireTime { get; set; }
	}
	//连接串
	public class Config
	{
		public string ip { get; set; }
		public string dbName { get; set; }
		public string userName { get; set; }
		public string passWord { get; set; }
	}
	public void GetToken()
	{
		if (!string.IsNullOrEmpty(lastToken.accessToken) && lastToken.expireTime > DateTime.Now.AddMinutes(+5))
		{
			Console.WriteLine($"accessToken 有效！accessToken:{lastToken.accessToken},expireTime:{lastToken.expireTime}");
			return;
		}
		Console.WriteLine($"accessToken 过期，重新获取！");
		var values = new Dictionary<string, string>{
		{"AppKey",appKey},
		{"appSecret",appSecret}
	};
		var result = PostRequestAsync(tokenUrl, values);
		var obj = JsonConvert.DeserializeObject<TokenResponse>(result.Result);
		lastToken.accessToken = obj.data.accessToken;
		lastToken.expireTime = obj.data.expireTime;
		Console.WriteLine($"accessToken 获取成功！accessToken:{lastToken.accessToken},expireTime:{lastToken.expireTime}");
	}

	public string GetData()
	{
		GetToken();
		var values = new Dictionary<string, string>{
		{"accessToken",lastToken.accessToken}
	};
		var result = PostRequestAsync(dataUrl, values);
		return result.Result;
	}

	async public Task<string> PostRequestAsync(string Url, Dictionary<string, string> values)
	{
		var content = new FormUrlEncodedContent(values);

		var response = await client.PostAsync(Url, content);

		var responseString = await response.Content.ReadAsStringAsync();

		return responseString;
	}
	void CreateProcedures()
	{
		var sql = @"SELECT name FROM sys.objects WHERE type = 'P'";
		var db = new RobotDBHelper(dbType, connString);
		var dbs = db.ExecuteDataSet(sql, out var err);
		if (!string.IsNullOrEmpty(err))
		{
			Console.WriteLine($"查询存储过程出错! err: {err}");
			return;
		}
		if (dbs != null && dbs.Tables != null)
		{
			var names = dbs.Tables[0].Rows.Cast<DataRow>().Select(row => row["name"].ToString()).ToArray();
			names.Dump();
			var proc1 = "MergeSCADA_SensorRealTime";
			var proc2 = "MergePumpRealData";
			var proc3 = "MergePumpAlarmTimely";
			if (!names.Contains(proc1))
			{
				Console.WriteLine($"创建存储过程{proc1}{Environment.NewLine}{sql_MergeSCADA_SensorRealTime}");
				db.ExecuteNonQuery(sql_MergeSCADA_SensorRealTime, out err);
				if (!string.IsNullOrEmpty(err))
				{
					Console.WriteLine($"创建存储过程{proc1}出错! err: {err}");
					return;
				}
			}
			else
			{
				Console.WriteLine($"{proc1}已存在");
			}

			if (!names.Contains(proc2))
			{
				Console.WriteLine($"创建存储过程{proc2}{Environment.NewLine}{sql_MergePumpRealData}");
				db.ExecuteNonQuery(sql_MergePumpRealData, out err);
				if (!string.IsNullOrEmpty(err))
				{
					Console.WriteLine($"创建存储过程{proc2}出错! err: {err}");
					return;
				}
			}
			else
			{
				Console.WriteLine($"{proc2}已存在");
			}

			if (!names.Contains(proc3))
			{
				Console.WriteLine($"创建存储过程{proc3}{Environment.NewLine}{sql_MergePumpAlarmTimely}");
				db.ExecuteNonQuery(sql_MergePumpAlarmTimely, out err);
				if (!string.IsNullOrEmpty(err))
				{
					Console.WriteLine($"创建存储过程{proc3}出错! err: {err}");
					return;
				}
			}
			else
			{
				Console.WriteLine($"{proc3}已存在");
			}
		}
	}
	const string sql_MergeSCADA_SensorRealTime = @"
	create procedure dbo.MergeSCADA_SensorRealTime @SensorID nvarchar(20),@LastValue FLOAT, @LastTime datetime
	as
	begin
	set nocount on;
	update SCADA_SensorRealTime set LastValue = @LastValue ,LastTime = @LastTime where SensorID = @SensorID
	if(@@ROWCOUNT=0)
	begin
	insert into SCADA_SensorRealTime(SensorID,LastValue,LastTime)values(@SensorID,@LastValue,@LastTime)
	end
	end";
	const string sql_MergePumpRealData = @"
	create procedure dbo.MergePumpRealData @BaseID nvarchar(20),@FOnline int, @F40009 float, @F40014 float, @LastTime datetime
	as
	begin
	set nocount on;
	update PumpRealData set FOnLine = @FOnline, F40009 = @F40009,F40014 = @F40014, FUpdateDate = @LastTime, TempTime = @LastTime where BASEID = @BaseID
	if(@@ROWCOUNT=0)
	begin
	insert into PumpRealData(BASEID,FOnLine,f40009,F40014,FUpdateDate,TempTime)values(@BaseID,@FOnline,@f40009,@F40014,@LastTime,@LastTime)
	end
	end";
	const string sql_MergePumpAlarmTimely = @"
	create procedure dbo.MergePumpAlarmTimely @pumpJZID nvarchar(20),@ParamID int, @Tips nvarchar(50), @LastTime datetime
	as
	begin
	set nocount on;
	update PumpAlarmTimely set BeginAlarmTime = @LastTime, ParamID = @ParamID, Tips = @Tips, AlarmOrWarn = 1 where PumpJZID = @pumpJZID
	if(@@ROWCOUNT=0)
	begin
	insert into PumpAlarmTimely(PumpJZID,BeginAlarmTime,ParamID,Tips,AlarmOrWarn)values(@pumpJZID,@LastTime,@ParamID,@Tips,1)
	end
	end";
}
```

