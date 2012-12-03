grant connect to openfire;

alter table ofconversation modify room null;
alter table ofconparticipant modify leftdate null;
alter table ofconparticipant modify nickname null;

create table if not exists openfire.msg (

    conversationID int not null,
    sentTs CTS,
    
    senderName varchar(256) not null,
    senderDomain varchar(256) not null,
    senderResource varchar(256) null,
    
    receiverName varchar(256) not null,
    receiverDomain varchar(256) not null,
    receverResource varchar(256) null,    

    body text,
    
    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)
)