import { configureStore } from "@reduxjs/toolkit";
import counterReducer from "../features/counter/counterSlice";
import postsReducer from "../features/posts/postSlice";
import sessionsReducer from "../features/sessions/sessionSlice";
import groupsReducer from "../features/groups/groupSlice";
import invitesReducer from "../features/groups/invites/inviteSlice";
import membershipsReducer from "../features/groups/memberships/membershipSlice";
import usersReducer from "../features/users/userSlice";
import shiftsReducer from "../features/posts/shifts/shiftSlice";
import notificationsReducer from "../features/notifications/notificationSlice";

export const store = configureStore({
  reducer: {
    counter: counterReducer,
    posts: postsReducer,
    sessions: sessionsReducer,
    groups: groupsReducer,
    invites: invitesReducer,
    memberships: membershipsReducer,
    users: usersReducer,
    shifts: shiftsReducer,
    notifications: notificationsReducer,
  },
});
