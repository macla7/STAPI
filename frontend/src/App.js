import React from "react";
import "./App.css";
import Posts from "./features/posts/Posts";
import SessionManager from "./features/sessions/SessionManager";
import NavBar from "./features/nav/NavBar";
import { Link, Outlet } from "react-router-dom";
import Notifications from "./features/notifications/Notifications";

function App() {
  return (
    <div className="App">
      <h1>The App baby</h1>
      <NavBar />
      <Notifications />
      <Outlet />
    </div>
  );
}

export default App;
