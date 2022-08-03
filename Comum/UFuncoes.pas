unit UFuncoes;

interface

uses
  System.Notification;

const
  TNameNotification = 'ChatNotification';
  TTitleNotification = 'Full Chat';

procedure ShowNotification(Msg: String);

implementation

procedure ShowNotification(Msg: String);
var
  Notify: TNotification;
  TNotificationCenterSMS: TNotificationCenter;
begin
  if (TNotificationCenterSMS.Supported) then
  begin
    Notify := TNotificationCenterSMS.CreateNotification;
    try
      Notify.Name := TNameNotification;
      Notify.Title := TTitleNotification;
      Notify.AlertBody := Msg;
      TNotificationCenterSMS.PresentNotification(Notify);
    finally
      Notify.Free;
    end;
  end;
end;

end.
