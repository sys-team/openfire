create or replace view openfire.uduser
    as select
        username, password, email, id, username as fullname
    from ea.account
    where confirmed=1
;


drop trigger if exists tiIU_dba_ofMessageArchive;

create or replace view dba.ofMessageArchive
    as select
        conversationID,
        string(senderName,'@',senderDomain, if senderResource is not null then '/'+senderResource endif ) as fromJID,
        string(receiverName,'@',receiverDomain, if receverResource is not null then '/'+receverResource endif ) as toJID,
        cast(datediff(second, '1970-01-01', sentTs) as bigint)*1000 +  datepart(ms, sentTs) as sentDate,
        body
    from openfire.msg
;


create or replace trigger tiIU_dba_ofMessageArchive
instead of insert, update on dba.ofMessageArchive
referencing new as inserted old as deleted
for each row
begin

    insert into openfire.msg with auto name
    select
        inserted.conversationID
        , inserted.body
        
        , left(inserted.fromJID, t.from_@_pos - 1) as senderName
        , substring(inserted.fromJID, from_@_pos + 1, t.from_slash_pos - t.from_@_pos - 1) as senderDomain
        , nullif(substring(inserted.fromJID, t.from_slash_pos +1),'') as senderResource
        
        , left(inserted.toJID, t.to_@_pos - 1) as receiverName
        , substring(inserted.toJID, t.to_@_pos + 1, t.to_slash_pos - t.to_@_pos - 1) as receiverDomain
        , nullif(substring(inserted.toJID, t.to_slash_pos +1),'') as receverResource
        
        , dateadd (ms, inserted.sentDate - t.sentSeconds*1000, dateadd (second, t.sentSeconds, '1970-01-01')) as sentTs
    from ( select
        LOCATE(inserted.fromJID, '@') as from_@_pos
        , isnull(nullif(LOCATE(inserted.fromJID, '/'),0),length(inserted.fromJID)+1) as from_slash_pos
        , LOCATE(inserted.toJID, '@') as to_@_pos
        , isnull(nullif(LOCATE(inserted.toJID, '/'),0),length(inserted.toJID)+1) as to_slash_pos
        , floor(inserted.sentDate/1000.0) as sentSeconds
    ) as t

end;