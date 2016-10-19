﻿SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EventStore](
	[EventId] [uniqueidentifier] NOT NULL,
	[Data] [text] NOT NULL,
	[EventType] [nvarchar](MAX) NOT NULL,
	[AggregateId] [nvarchar](445) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[CorrelationId] [uniqueidentifier] NOT NULL,
CONSTRAINT [PK_EventStore] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
 CONSTRAINT [UIX_AggregateId_Version] UNIQUE NONCLUSTERED 
(
	[AggregateId] ASC,
	[Version] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

CREATE NONCLUSTERED INDEX [IX_CorrelationId] ON [dbo].[EventStore]
(
	[CorrelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [IX_Timestamp] ON [dbo].[EventStore]
(
	[Timestamp] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

CREATE NONCLUSTERED INDEX [IX_Timestamp_EventId_CorrelationId] ON [dbo].[EventStore]
(
	[Timestamp] DESC,
	[EventId] ASC,
	[CorrelationId] ASC
)
INCLUDE ([EventType]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
GO

CREATE STATISTICS [ST_CorrelationId_Timestamp] ON [dbo].[EventStore]([CorrelationId], [Timestamp])
GO

CREATE STATISTICS [ST_EventId_CorrelationId_Timestamp] ON [dbo].[EventStore]([EventId], [CorrelationId], [Timestamp])
GO
