import React, { useState } from "react";
import { useDispatch } from "react-redux";
import { registerUserAsync } from "./sessionSlice";

function Register() {
  const dispatch = useDispatch();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [avatar, setAvatar] = useState("");

  function handleRegister(e) {
    e.preventDefault();

    const data = new FormData();

    data.append("user[avatar]", e.target.avatar.files[0]);
    data.append("user[email]", e.target.email.value);
    data.append("user[password]", e.target.password.value);
    data.append("user[password]", e.target.password.value);
    data.append(
      "user[client_id]",
      "Lm-9XiqY8dZOCoeX3mZrDhCjFY99IAUnp-Y82YpZz_k"
    );

    dispatch(registerUserAsync(data));
  }

  return (
    <div>
      <form onSubmit={(e) => handleRegister(e)}>
        <label>
          Email
          <input
            type="email"
            id="email"
            name="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          ></input>
        </label>

        <label>
          Password
          <input
            type="password"
            id="password"
            name="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          ></input>
        </label>

        <label>
          Avatar
          <input
            type="file"
            id="avatar"
            name="avatar"
            onChange={(e) => setAvatar(e.target.files[0])}
          ></input>
        </label>

        <input type="submit" value="Sign up" />
      </form>
    </div>
  );
}

export default Register;
