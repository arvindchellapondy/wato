App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',
  hasPlacedBets: false,

  init: async function() {
    return await App.initWeb3();
  },

  initWeb3: async function() {

    if (typeof web3 !== 'undefined') {
        
      ethereum.enable().then(() => {
      web3 = new Web3(web3.currentProvider);
      });

      } else {
      // If no injected web3 instance is detected, fallback to the TestRPC
      web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));			
      }

      App.web3Provider=web3.currentProvider;

  return App.initContract();
  },

  initContract: function() {
    $.getJSON("Bet.json", function(bet) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Bet = TruffleContract(bet);
      // Connect provider to interact with contract
      App.contracts.Bet.setProvider(App.web3Provider);

      App.listenForEvents();

      return App.render();
    });
  },

    // Listen for events emitted from the contract
    listenForEvents: function() {
      App.contracts.Bet.deployed().then(function(instance) {
        // Restart Chrome if you are unable to receive this event
        // This is a known issue with Metamask
        // https://github.com/MetaMask/metamask-extension/issues/2393
        instance.betEvent({}, {
          fromBlock: 0,
          toBlock: 'latest'
        }).watch(function(error, event) {
          console.log("event triggered", event)
          // Reload when a new vote is recorded
          //App.render();
        });
      });
    },

  render: function() {
    var bettingInstance;
    var loader = $("#loader");
    var content = $("#content");

    //$("#claimProfit").hide();
    loader.show();
    content.hide();

    (async() => {
      const accounts = await ethereum.request({ method: 'eth_accounts' });
      console.log(accounts);
      App.account = accounts[0];
      $("#accountAddress").html("Your Account: " + accounts);
            })();


    // window.web3
    // const accounts = web3.eth.accounts;
    // console.log(accounts[0]);
    // App.account = accounts;
    //     $("#accountAddress").html("Your Account: " + accounts);

    //Load account data
    // web3.eth.getCoinbase(function(err, account) {
    //   if (err === null) {
    //     App.account = account;
    //     $("#accountAddress").html("Your Account: " + account);
    //   }
    // });

    // Load contract data
    App.contracts.Bet.deployed().then(function(instance) {
      bettingInstance = instance;
      return bettingInstance.teamCount();
    }).then(function(teamCount) {
      var betPositions = $("#BetPositions");
      betPositions.empty();

      var betPositionSelect = $('#betPositionSelect');
      betPositionSelect.empty();

      for (var i = 1; i <= teamCount; i++) {
        bettingInstance.teams(i).then(function(team) {
          var id = team[0];
          var name = team[1];
          var positionCount = team[2];

          // Render bet options and positions
          var teamPositionTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + positionCount + "</td></tr>"
          betPositions.append(teamPositionTemplate);

          var betOption = "<option value='" + id + "' >" + name + "</ option>"
          betPositionSelect.append(betOption);
        });
      }

      bettingInstance.isBetsClosed().then(function(instance){
        console.log("bets close" + instance );
        
        if(instance){
          $("#claimProfit").show();
        }else{
          $("#claimProfit").hide();
        }
      });

      return bettingInstance.bettors(App.account);
    }).then(function(bettor) {
      console.log("has placed bets : "+bettor[1]);
      // Do not allow a bettor to bet if already bet
      if(bettor[1]) {
        $('form').hide();
      }
      loader.hide();
      content.show();
      return bettingInstance;
    });
  },

  bet: function() {
    var betPositionId = $('#betPositionSelect').val();
    App.contracts.Bet.deployed().then(function(instance) {
      return instance.bet(betPositionId, { from: App.account, value : 1000000000000000000 });
    }).then(function(result) {
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  }, 


    claimProfit: function() {
    
    App.contracts.Bet.deployed().then(function(instance) {
      return instance.claimEth({ from: App.account});
    }).then(function(result) {
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
      console.log(err.data);
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
