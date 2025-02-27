import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Char "mo:base/Char";
import Float "mo:base/Float";
import Option "mo:base/Option";

import JSON "../utils/Json";
import RandomUtil "../utils/RandomUtil";
import Utils "../utils/Utils";
import Int "mo:base/Int";

import ENV "../utils/Env";
import Nat64 "mo:base/Nat64";
import Debug "mo:base/Debug";

import TEntity "./entity.types";
import TGlobal "./global.types";

module{
    
    public type attribute = Text;
    public type quantity = Float;
    public type duration = Nat;

    public type Action = {
        intervalStartTs : Nat;
        actionCount : Nat;
    };

    public type ActionArg = 
    {
        #default : {actionId: Text; };
        #burnNft : {actionId: Text; index: Nat32; };
        #verifyTransferIcp : {actionId: Text; blockIndex: Nat64; };
        #verifyTransferIcrc : {actionId: Text; blockIndex: Nat; };
        #claimStakingRewardNft : {actionId: Text; };
        #claimStakingRewardIcp : {actionId: Text; };
        #claimStakingRewardIcrc : {actionId: Text; };
    };
    
    public type MintToken = 
    {
        quantity : Float;
        baseZeroCount : Nat;
        canister : Text;
    };
    public type MintNft = 
    {
        name : Text;
        canister : Text;
        assetId: Text;
        collection:  Text;
        metadata: Text;
    };
    public type ActionOutcomeOption = {
        weight: Float;
        option : {
            #mintToken : MintToken;
            #mintNft : MintNft;
            #setEntityAttribute : (
                ? TGlobal.worldId,
                TGlobal.groupId,
                TGlobal.entityId,
                attribute
            );
            #spendEntityQuantity : (
                ? TGlobal.worldId,
                TGlobal.groupId,
                TGlobal.entityId,
                quantity
            );
            #receiveEntityQuantity : (
                ? TGlobal.worldId,
                TGlobal.groupId,
                TGlobal.entityId,
                quantity
            );
            #renewEntityExpiration : (
                ? TGlobal.worldId,
                TGlobal.groupId,
                TGlobal.entityId,
                duration
            );
            #reduceEntityExpiration : (
                ? TGlobal.worldId,
                TGlobal.groupId,
                TGlobal.entityId,
                duration
            );
            #deleteEntity : (
                ? TGlobal.worldId,
                TGlobal.groupId,
                TGlobal.entityId
            );
        }
    };
    public type ActionOutcome = {
        possibleOutcomes: [ActionOutcomeOption];
    };
    public type ActionResult = {
        outcomes: [ActionOutcome];
    };

    public type ActionPlugin = 
    {
        #burnNft : { canister: Text;};
        #verifyTransferIcp : { amt: Float; toPrincipal : Text; };
        #verifyTransferIcrc : {canister: Text; amt: Float; baseUnitCount: Nat;  toPrincipal : Text; };
        #claimStakingRewardNft : { canister: Text; requiredAmount : Nat; };
        #claimStakingRewardIcp : { requiredAmount : Float;  };
        #claimStakingRewardIcrc : { canister: Text; requiredAmount : Float; baseUnitCount: Nat; };
    };

    public type ActionConstraint = 
    {
        timeConstraint: ? {
            intervalDuration: Nat; 
            actionsPerInterval: Nat; 
        };
        entityConstraint : ? [{ 
            worldId: Text; 
            groupId: Text; 
            entityId: Text; 
            equalToAttribute: ?Text; 
            greaterThanOrEqualQuantity: ?Float; 
            lessThanQuantity: ?Float; 
            notExpired: ?Bool
        }];
    };
    public type ActionConfig = 
    {
        aid : Text;
        name : ?Text;
        description : ?Text;
        tag : ?Text;
        actionPlugin: ?ActionPlugin;
        actionConstraint: ?ActionConstraint;
        actionResult: ActionResult;
    };

    public type ActionResponse = (Action, [TEntity.Entity], [MintNft], [MintToken]);
}