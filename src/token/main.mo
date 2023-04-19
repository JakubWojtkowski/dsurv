import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Hash "mo:base/Hash";

actor Token {
    let owner : Principal = Principal.fromText("phrg6-d2edg-beviy-yvdyy-yckcs-a7dqa-anzkm-x3pnv-4ga24-mfr4x-fqe");
    let totalSupply : Nat = 1000000000;
    let symbol : Text = "DWOJC";

    private stable var balanceEntries : [(Principal, Nat)] = [];

    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

    if (balances.size() < 1) {
        balances.put(owner, totalSupply);
    };

    public query func balanceOf(who : Principal) : async Nat {

        let balance : Nat = switch (balances.get(who)) {
            case null 0;
            case (?result) result;
        };

        return balance;
    };

    public query func getSymbol() : async Text {
        return symbol;
    };

    public shared (message) func payOut() : async Text {
        if (balances.get(message.caller) == null) {
            let amount = 10000;
            let result = await transfer(message.caller, amount);
            return result;
        } else {
            return "Already Claimed the Tokens";
        };
    };

    public shared (message) func transfer(to : Principal, amount : Nat) : async Text {
        let fromBalance = await balanceOf(message.caller);
        if (fromBalance > amount) {
            let newFromBalance : Nat = fromBalance - amount;
            balances.put(message.caller, newFromBalance);

            let toBalance = await balanceOf(to);
            let newToBalance = toBalance + amount;
            balances.put(to, newToBalance);
            return "Success";
        } else {
            return "Insufficient Funds";
        };
    };

    system func preupgrade() {
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
        if (balances.size() < 1) {
            balances.put(owner, totalSupply);
        };
    };
};
