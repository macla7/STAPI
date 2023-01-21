import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  fetchNotificationsAsync,
  selectNotifications,
  selectStatus,
} from "./notificationSlice";
import { selectUserId, selectIsLoggedIn } from "../sessions/sessionSlice";

function Notifications() {
  const notifications = useSelector(selectNotifications);
  const status = useSelector(selectStatus);
  const userId = useSelector(selectUserId);
  const isLoggedIn = useSelector(selectIsLoggedIn);
  const [notificationsList, setNotificationsList] = useState("");
  const dispatch = useDispatch();

  // Called on initialise, because dispatch changes (on intialise)
  // and on notifications.length change
  useEffect(() => {
    if (isLoggedIn) {
      dispatch(fetchNotificationsAsync());
    }
  }, [dispatch, notifications.length, userId]);

  function listNotifications(notifications) {
    return notifications.map((notification) => (
      <li key={notification.id}>
        Notification: {notification.id} - {notification.description}
      </li>
    ));
  }

  useEffect(() => {
    setNotificationsList(listNotifications(notifications));
  }, [notifications.length, notifications[0]]);

  return (
    <div>
      <h2>Notifications</h2>
      {notificationsList}
    </div>
  );
}

export default Notifications;
