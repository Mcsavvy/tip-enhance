import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.5.4/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

Clarinet.test({
    name: "tip-enhance: Test Project Creation",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!;
        const block = chain.mineBlock([
            Tx.contractCall('tip-enhance', 'create-project', [
                types.ascii('Web3 Creator Project'),
                types.utf8('Innovative blockchain content creation'),
                types.uint(100000),
                types.uint(0),
                types.uint(chain.blockHeight + 100)
            ], deployer.address)
        ]);

        assertEquals(block.receipts.length, 1);
        block.receipts[0].result.expectOk();
    }
});

// Additional tests will follow the same pattern as the original tests