import React, { Component } from 'react'
// https://github.com/trufflesuite/drizzle-react-components/tree/master/src
import { AccountData, ContractData, ContractForm } from 'drizzle-react-components'
// import { ProposalContractForm } from './MyContractForm.js'
import logo from '../../logo.png'

class Home extends Component {
  render() {
    return (
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1 header">
            <img src={logo} alt="lets-meet-logo" />
            <h1>ThirdPlanet Let&apos;s Meet dApp Example</h1>
            <p>Frontend to an Ethereum smart contract using the <a href="https://truffleframework.com/docs/drizzle/overview">Drizzle Framework</a></p>
          </div>

          <div className="pure-u-1-1">
            <h2>Active Account</h2>
            <AccountData accountIndex="0" units="ether" precision="3" />
          </div>

          <div className="pure-u-1-1">
          <p><strong>Number of Proposals</strong>: <ContractData contract="LetsMeet" method="getProposalCount" /></p>
          </div>

          <div className="pure-u-1-1">
            <h2>Let&apos;s Meet!</h2>
            <ContractForm contract="LetsMeet" method="newProposal" sendArgs={{gas: 2000000, gasPrice: '8000000000'}} />
          </div>

          <div className="pure-u-1-1">
            <h2>Last Proposal</h2>
            <p><ContractData contract="LetsMeet" method="lastProposal" /></p>
          </div>
        </div>
      </main>
    )
  }
}

export default Home
