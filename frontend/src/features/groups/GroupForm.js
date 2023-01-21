import React, { useState } from "react";
import { useDispatch } from "react-redux";
import { createGroupAsync } from "./groupSlice";

function GroupForm() {
  const dispatch = useDispatch();
  const [name, setName] = useState("");

  function submitHandler(e) {
    e.preventDefault();
    const formData = {
      group: {
        name: name,
      },
    };
    dispatch(createGroupAsync(formData));
    resetState();
  }

  function resetState() {
    setName("");
  }

  return (
    <div>
      <h1>Group Form</h1>
      <form>
        <textarea
          name="name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <button type="submit" onClick={(e) => submitHandler(e)}>
          Submit
        </button>
      </form>
    </div>
  );
}

export default GroupForm;
