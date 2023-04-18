import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor Token {
    var owner : Principal = Principal.fromText("phrg6-d2edg-beviy-yvdyy-yckcs-a7dqa-anzkm-x3pnv-4ga24-mfr4x-fqe");
    var totalSupply : Nat = 1000000000;
    var symbol : Text = "DWOJC";

    var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);

    balances.put(owner, totalSupply);

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
};
