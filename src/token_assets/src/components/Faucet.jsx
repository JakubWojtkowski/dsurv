import React, { useState } from "react";
import { token, canisterId, createActor } from "../../../declarations/token";
import { AuthClient } from "../../../../node_modules/@dfinity/auth-client";

function Faucet() {

  const [isDisabled, setDisable] = useState(false);
  const [btnText, setText] = useState("Gimmie gimmie");

  async function handleClick(event) {
    setDisable(true);

    const authClient = await AuthClient.create();
    const identity = await authClient.getIdentity();

    const authenticatedCanister = createActor(canisterId, {
      agentOptions: {
        identity,
      },
    });

    const result = await token.payOut();
    setText(result);
  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>Get your free DSurv tokens here! Claim 10,000 DWOJC token to your account.</label>
      <p className="trade-buttons">
        <button 
        id="btn-payout"
        onClick={handleClick} 
        disabled={isDisabled}
        >
          {btnText}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
